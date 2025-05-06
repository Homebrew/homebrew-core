class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "6399a7a152f25af7ff61425e8af96212d899b79984194117fdef06f74f578add"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c720bee3a92b0a52111fd179a25c5444f1b05fba9a4d413c32c37e6a383d046"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c44116efdfc183add074dbbafed7811e209f206855eb9212f1e7ed695f39b41d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7982119f82481ce2cab8cbbf1885fd832061be6164300959b202ca47b0657dd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8302b2acd7e0f37279c50fdb53a771c4527bb0d95704683605e689678bccd5ba"
    sha256 cellar: :any_skip_relocation, ventura:       "be6dbc58a4d32d43c1a967090e91d57f8053e821af78aab36cc8342b6ae21d84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac19d6b0a2caa42c0635d5ca2e2c91e680596084c860cb354b76ff27248eae13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "283d28999fbac71c46cb1fa775ffd56dc2933606da0ac8a34a0659d1e0c9c801"
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
