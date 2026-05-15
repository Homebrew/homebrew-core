class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.57.1.tar.gz"
  sha256 "7c980244c7f9aafbeca20977598ee0012d2e17beb9d54a63fcc448451917ac3c"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f48c46c2d62c0fb821385d289603732b6cb1ac3db21dffcad47a814953d292f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83acdaa1f78d0dace4372373b8c33620c3b0f84621548cbd699dec0427a746e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ee5ba3dde20aa8fe039713f5ff0f8d1d5c59a59c7656a3ebfb5103e561c112a"
    sha256 cellar: :any_skip_relocation, sonoma:        "69dd6da4336583e1805d8fc7e4d101ffc54c91ab54d98b89508297dff695bfd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06188b6cd0b134a4b22d738eb70866248cf401957ffd45263d822b2bb1280f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3081e4bb9d48d605b2b0c34cc180851e8369591f4446fe5f4dcb88a59dcbbe9e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
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
    node_version = "24.15.0"
    system bin/"proto", "install", "node", node_version
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match node_version, shell_output("#{node} --version")

    (testpath/"test.js").write <<~JS
      console.log('hello');
    JS
    assert_equal "hello", shell_output("#{node} #{testpath}/test.js").chomp
  end
end
