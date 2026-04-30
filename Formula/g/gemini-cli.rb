class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.40.1.tgz"
  sha256 "893205127c072d3baa2fba419a28081b9fd5cb77c745883139dd9e3e2c1a2b2d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "469d65f595b507baef8cf349a363f2ef3844d0d89d805ebdf146707620616569"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "469d65f595b507baef8cf349a363f2ef3844d0d89d805ebdf146707620616569"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "469d65f595b507baef8cf349a363f2ef3844d0d89d805ebdf146707620616569"
    sha256 cellar: :any_skip_relocation, sonoma:        "07096f835e06edf9ccc591603c5a9f0ce7a3ae877eb6bc36ce79e9e007b6b922"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fcb15ae80ffe151cc65ba8f2fc92c34bc0e88fadef7d0c55c5cd88cbc063ca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b351b6da6e4e35b234436c4cabb863f8a220d696ad85b19ee72c02acb61d4817"
  end

  depends_on "glib"
  depends_on "libsecret"
  depends_on "node"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "pkgconf" => :build
    depends_on "python@3.14" => :build
    depends_on "pcre2"
  end

  def install
    if OS.linux?
      glib = Formula["glib"].opt_lib
      libsecret = Formula["libsecret"].opt_lib
      ENV.append_path "PKG_CONFIG_PATH", "#{glib}/pkgconfig"
      ENV.append_path "PKG_CONFIG_PATH", "#{libsecret}/pkgconfig"
      ENV.append_path "PKG_CONFIG_PATH", Formula["pcre2"].opt_lib/"pkgconfig"
      rpath_flags = [
        "-Wl,-rpath,#{glib}",
        "-Wl,-rpath,#{libsecret}",
        "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib",
      ].join(" ")
      ENV.append "LDFLAGS", "-L#{glib} -L#{libsecret} #{rpath_flags}"
    end

    system "npm", "install", *std_npm_args(prefix: libexec)
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native_prebuild = "#{os}-#{arch}"

    libexec.glob("**/node_modules/**/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != native_prebuild
    end

    # Selectively run `npm run build` for keytar to generate `keytar.node`
    # Use an "invincible" glob to find keytar directory at any depth within node_modules
    keytar_dir = libexec.glob("**/node_modules/{@github/,}keytar").first
    if keytar_dir
      cd keytar_dir do
        system "npm", "run", "build"
      end
    end

    if OS.linux?
      rpath = [
        Formula["glib"].opt_lib,
        Formula["libsecret"].opt_lib,
        HOMEBREW_PREFIX/"lib",
      ].join(":")
      libexec.glob("**/*.node").each do |node_file|
        system "patchelf", "--set-rpath", rpath, node_file
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end
