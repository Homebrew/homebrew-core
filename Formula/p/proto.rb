class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.53.1.tar.gz"
  sha256 "008e20f9177209421be79ef275d79c8153ed962e4e7f8ba979c387ae4b6d1f26"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a08e847caa9e2c2ed2254974ffc78af2d18fdc5438cadde3a7e5dbb691399d3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2484628b0a7900f236eff747c6c88534c0a5fbc3df1f6c917d054b88147dba48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06c1238df1026b28bce6b7ae968aba8bac47175baa407e74bfc134dedb5fe9f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ee47b563e29146955b6e0d38bc93ea9c67d1df5f3019afef504de1ee9d31d58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7a545355dcb525e4d4809860fea616a20f360accc4e854b9953fb6bec77697b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f20f4f39b92684ec70e4127721f67701034280f44e90f63cf8c673da177c2fe6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_LOOKUP_DIR: opt_prefix/"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin/"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.proto/shims/node #{path}").strip
    assert_equal "hello", output
  end
end
