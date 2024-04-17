class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.34.4.tar.gz"
  sha256 "6bf9f109e42132d241d212d89af7bef2949b123f64a471af112c1986a0696569"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ba47be08e70571dc8bc3fef8991f117019548dc9de1a004f87d318d91706b9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "466e9ed433f39fc2415e10c35728007199c37fa8ecbb9f9ec00735372f89a4b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f4416515d7f3b5b28043257a053d05ddf01f8c31982ee5697d97b5b0d363468"
    sha256 cellar: :any_skip_relocation, sonoma:         "66311088e7f97c29b4bad45d9482716fa8bb0eb14162b79017c25ac3649a1b34"
    sha256 cellar: :any_skip_relocation, ventura:        "9dc2ce50bbee225139e2a2f7101c535d83ee54ee6ce8e66c4ea248aa6b8dd2cb"
    sha256 cellar: :any_skip_relocation, monterey:       "0779dcdc914deea4246b7b5af5466df3b84027e9345371741f6b9d9b17912d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "944e7589466ccbeb9fe40657a7eb605e912672047d935a4a0346b4dc361e9ce5"
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
