class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "2fe10361ed64f6474f6885c7fba13c84663cba5140b2ecda04c1f1e0e52d7d05"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b78405c77497121567b87da0a28fa67761b37a6f4d9ee34a09fe3cc6057e252"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75c0e7ae8a43b7c029f9223246d46431ce18e362eb4d518e4c6690a953e8a2bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50dc5d420b5c2d4fe99e06dac8cc7564114682070eaf8cefa20b708d48fdd812"
    sha256 cellar: :any_skip_relocation, sonoma:         "caad75a929d3a03af39469ad2332508c7869de82f083696ea37647d38cda90e4"
    sha256 cellar: :any_skip_relocation, ventura:        "a797578839297d39e0b608580f4561286a37a901ad89976d3b491134a24dbe8a"
    sha256 cellar: :any_skip_relocation, monterey:       "e005ea9f2b5eb1b4254fcc389ca1342e393fc82b6db1789261526fc6c13a06e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac006f3b3065c18660d5d9cd2192a3edb366e377ceaa1e2c823c8225f6ffa592"
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

      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_INSTALL_DIR: opt_prefix/"bin"
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
