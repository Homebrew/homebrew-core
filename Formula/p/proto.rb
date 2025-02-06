class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "e545fa31935bd31fd1b05ec13e2de377824f63953ba014ce572e5a2cf69f2834"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d024c49a2dc5fea68872e0630ea7d465081117dd46806701c1f9cd9a0d588134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3662359f704f1bc2885afb2afad0ed26787c9038d3afead0018b48de56869360"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0e6207951a3f3bcbd7cbea72ac71f4e3be892f6ed39ebab69f660884fe221f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0110b442e5402618a399040dd92d156da145f410f8ab658c15e36a593eef46e1"
    sha256 cellar: :any_skip_relocation, ventura:       "9025e2c92dc797d596864d7d85168fb45baedc9179ef0bbd67cd6c8f49ef58aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "693f06d1e1871da8240fe458baa2e72890f42660d6e247e7f24b47b9a494ab40"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

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
