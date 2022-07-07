class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  license "Apache-2.0"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/1.5.0.tar.gz"
    sha256 "f53e459ef6c7227df922a76fb62e350c90d52d30bfaa84b90feda9731bb98655"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.17.0.tar.gz"
      sha256 "b3f0a2261437b21b3e2465b7755edf0c33f0305a112bd9a36e1b3ec74f96b098"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "3e6120f5f7a3da7d41aed6d3945d111cbf3e5871c5d4b8744e044ad94f49ec2e"
    sha256 arm64_big_sur:  "50314c7f799c880d27280831bd83c1af4622b9d5e898a96c363d04e719013de1"
    sha256 monterey:       "e7b3135c115fe7aa89a8a8785a915e4f1d9f19500512bc393368b190fdecf349"
    sha256 big_sur:        "6e4df7ecd39a6eb72b4cb78ca7bc1f92a67b7ebe8b71c63571f05ca33506b8fa"
    sha256 catalina:       "5c66db4aa5106173b05997799ca8460384ca5bfd3482f04651fe70a8781212e1"
    sha256 x86_64_linux:   "6241a16177243023dec99e9b7e3da77da9a861314ada2a647f138be70d0868c8"
  end

  head do
    url "https://github.com/crystal-lang/crystal.git"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git"
    end

    uses_from_macos "libffi" # for the interpreter
  end

  depends_on "bdw-gc"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "openssl@1.1" # std uses it but it's not linked
  depends_on "pcre"
  depends_on "pkg-config" # @[Link] will use pkg-config if available

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # Every new crystal release is built from the previous one. The exceptions are
  # when crystal make a minor release (only bug fixes). Reason is because those
  # bugs could make the compiler from stopping compiling the next compiler.
  #
  # See: https://github.com/Homebrew/homebrew-core/pull/81318
  resource "boot" do
    platform = case OS.kernel_name
    when "Darwin" then "darwin-universal"
    else "#{OS.kernel_name.downcase}-#{Hardware::CPU.arch}"
    end

    checksums = {
      "darwin-universal" => "e7f9b3e1e866dc909a0a310238907182f1ee8b3c09bd8da5ecd0072d99c1fc5c",
      "linux-x86_64"     => "a5bdf1b78897b3cdc7d715b5f7adff79e84401d39b7ab546ab3249dc17fc770c",
    }
    boot_version = Version.new("1.4.1-1")

    url "https://github.com/crystal-lang/crystal/releases/download/#{boot_version.major_minor_patch}/crystal-#{boot_version}-#{platform}.tar.gz"
    version boot_version
    sha256 checksums[platform]
  end

  def install
    llvm = deps.find { |dep| dep.name.match?(/^llvm(@\d+)?$/) }
               .to_formula

    (buildpath/"boot").install resource("boot")
    ENV.append_path "PATH", "boot/bin"
    ENV["CRYSTAL_LIBRARY_PATH"] = ENV["HOMEBREW_LIBRARY_PATHS"]
    ENV.append_path "CRYSTAL_LIBRARY_PATH", MacOS.sdk_path_if_needed/"usr/lib" if MacOS.sdk_path_if_needed
    ENV.append_path "LLVM_CONFIG", llvm.opt_bin/"llvm-config"

    crystal_install_dir = libexec
    # Avoid embedding HOMEBREW_PREFIX references in `crystal` binary.
    config_library_paths = ENV["CRYSTAL_LIBRARY_PATH"].gsub(
      HOMEBREW_PREFIX,
      "\\$$ORIGIN/#{HOMEBREW_PREFIX.relative_path_from(crystal_install_dir)}",
    )
    crystal_build_opts = [
      "release=true",
      "FLAGS=--no-debug",
      "CRYSTAL_CONFIG_LIBRARY_PATH=#{config_library_paths}",
    ]
    if build.head?
      crystal_build_opts << "interpreter=true"
      crystal_build_opts << "CRYSTAL_CONFIG_BUILD_COMMIT=#{Utils.git_short_head}"
    end

    # Build crystal
    (buildpath/".build").mkpath
    system "make", "deps"
    system "make", "crystal", *crystal_build_opts

    # Build shards (with recently built crystal)
    #
    # Setup the same path the wrapper script would, but just for building shards.
    # NOTE: it seems that the installed crystal in bin/"crystal" can be used while
    #       building the formula. Otherwise this ad-hoc setup could be avoided.
    embedded_crystal_path = Utils.safe_popen_read(buildpath/".build/crystal", "env", "CRYSTAL_PATH").strip
    ENV["CRYSTAL_PATH"] = "#{embedded_crystal_path}:#{buildpath}/src"

    # Install shards
    resource("shards").stage do
      system "make", "bin/shards", "CRYSTAL=#{buildpath}/bin/crystal",
                                   "SHARDS=false",
                                   "release=true",
                                   "FLAGS=--no-debug"

      # Install shards
      bin.install "bin/shards"
      man1.install "man/shards.1"
      man5.install "man/shard.yml.5"
    end

    # Install crystal
    crystal_install_dir.install ".build/crystal"
    pkgshare.install "src"

    embedded_crystal_path = "$(\"#{crystal_install_dir}/crystal\" env CRYSTAL_PATH)"
    crystal_env = {
      CRYSTAL_PATH:         "${CRYSTAL_PATH:-#{embedded_crystal_path}:#{pkgshare}/src}",
      CRYSTAL_LIBRARY_PATH: "${CRYSTAL_LIBRARY_PATH:+${CRYSTAL_LIBRARY_PATH}:}#{HOMEBREW_PREFIX}/lib",
      PKG_CONFIG_PATH:      "${PKG_CONFIG_PATH:+${PKG_CONFIG_PATH}:}#{Formula["openssl@1.1"].opt_lib}/pkgconfig",
    }
    (bin/"crystal").write_env_script crystal_install_dir/"crystal", crystal_env

    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "_crystal"

    man1.install "man/crystal.1"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end
