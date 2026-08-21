class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "bdc1cffec265d595efa51eb2c2c79602e857fa2ba335866d574a1505cc45c976"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79cc69b4fb636990d82bb49aaf576022a7e50a356b069dfff3533daf93900fc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79cc69b4fb636990d82bb49aaf576022a7e50a356b069dfff3533daf93900fc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79cc69b4fb636990d82bb49aaf576022a7e50a356b069dfff3533daf93900fc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "085ca6e46676e54b8af33a48f957abfea863cf809288d0cef7fd0f2163df7ec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be57080e4ed3d11fab25569a55fdc7862e3acaafb1e07ffd1ddf29b3e24172b0"
    sha256 cellar: :any,                 x86_64_linux:  "d4fedea1dbc654ec7aa0d68ab317d0373f37c2c355f6044affc260ca94800201"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crit --version")

    (testpath/"hello.md").write("# Hello\n")
    system bin/"crit", "comment", "-o", testpath, "hello.md:1", "looks good"

    assert_path_exists testpath/"reviews"
  end
end
