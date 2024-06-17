class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.36.2.tar.gz"
  sha256 "776e26144bc07673a342934abf492156fbaa56c8682443a95ae1904cec6abebd"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e5ff3d852020cb798a24770542428072015da7cf97f240492e2188645da0389"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b903e6a2eef9df902b9377a50f2aa793ff10e51da79887bb26bce1446e77d83d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2369f90ba512ef674e9e19f4003591ce89eb8cbde3ecd348a8090fbe5e923fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "a062d2624c5130b0533ad50fe4ee8c21694b85c979fccec41f4c111923c3916c"
    sha256 cellar: :any_skip_relocation, ventura:        "c81c17af72c4d9edbe8a3bcb337c9f36df4f794961b52516b10909b5fcb6ec64"
    sha256 cellar: :any_skip_relocation, monterey:       "473ebf0bd7071a6ef5c278a6a4165f4216eea5459e1af73c37c4238064c95f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18016d6b8cb0621ac2aed2dd727e8c0d41d7b92817635fdb1114b8e14d76e7b4"
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
