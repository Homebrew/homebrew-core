class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.55.4.tar.gz"
  sha256 "229ab227f6cbf41863ef95ccb16939e783a37a684135aeab1fe882f38aed1fa6"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f632fbe42dd356c43f7619292d96f4cec791896cf53508aacc020eb48c6fa41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c95450e3999e6a742ecd2dd42cffe84cabd9f70f703c4a3e7ff848bd25002f1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "471615787730d1925b3be91842565975f4e665bc2a7afdae2fd2b8982d1e85df"
    sha256 cellar: :any_skip_relocation, sonoma:        "02347d8a1383e5530f6cada88ccf0834ef63711b0cc1ede0a606434bed133af5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "475e1cfedf277a649cc0162ab5791897fd0db43f177c8a1e8035398ee014e4b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "008b51c4471f14187437a312ef0f8bffaff9894bb2fce22acd818c6db72b5bb0"
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
