class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "40e69b8ffe128f33c6dee5ecb1279eb2772ad45b5770d4ec7015418c940c8ce3"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b96907930958b2dabf78781c8d75132de6cf794c1b03aeae98d78feb4e136fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71fe1df2c3790398ef55ba671d6f62b468ccbc3c2e6d51bbaaa481dae3457d53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aec13844ea03165d696a716806ff8f22b079694edece7e2cb48a1188d38611b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3113ea580dcccdaa98637d95f31017f4d1ae8dd4d52e1af7e997be739ede830a"
    sha256 cellar: :any_skip_relocation, ventura:        "c2fe2c4742658a3416eea2b33828e42557d9333c867cbb1f8d9a232c4a0f75c9"
    sha256 cellar: :any_skip_relocation, monterey:       "c2b5f580c356f972e3ed2f93745a68512bd5b6285ad9bfb9a5e4a08df1877f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac4b51330f26ac16addb1ef5fe100fc6c6ace5058d6f6503181d2a62aaa08245"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
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
