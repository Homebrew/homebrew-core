class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.41.5.tar.gz"
  sha256 "a41b59dbbb0d6dc500d80f0f5183bb95c424aa9580243fd74c83446b404892a9"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24ffd788c903e0eb14fd414a79a7bd6fff45d59d4821cc61444d380424ee3cfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b80a29d1ddda1c37a6a189b5c45b9a892b460e1dd0ddc3ff143444f06237f053"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35ab596341cf2c233387b96e816134edb8e6e6f999f224c1c753fe8c839aac36"
    sha256 cellar: :any_skip_relocation, sonoma:        "0471d23e3a2b6533796d549fe8bd7d4ba1bcb1646de7899f25baade057c94db1"
    sha256 cellar: :any_skip_relocation, ventura:       "fbb31db3422180de276cdad2dc3e82e2d842cf37d2d71ed4b218dab6bc118e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f5f1e6ab62f7cd1c4230c779201083ec4c7de4acffdfd49971c68e40773d1a6"
  end

  depends_on "pkg-config" => :build
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
