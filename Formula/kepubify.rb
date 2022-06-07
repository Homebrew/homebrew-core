class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/pgaskin/kepubify/archive/v4.0.4.tar.gz"
  sha256 "a3bf118a8e871b989358cb598746efd6ff4e304cba02fd2960fe35404a586ed5"
  license "MIT"
  head "https://github.com/pgaskin/kepubify.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "190fcf71bfa7069608000948821b08e64ebf230bef805c6285d365bf3bc22a04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "813a2a57f898d3146f374a6c77e15eeba052d434e78d881602d88e5cb8162d1c"
    sha256 cellar: :any_skip_relocation, monterey:       "b9944734812a60b9fff0895d49385d3ce15321da417a292e23760ab31ac54135"
    sha256 cellar: :any_skip_relocation, big_sur:        "07e78d188d1c64ac4ab876f6afb18458419ac056c791c1e2227788136639c3d2"
    sha256 cellar: :any_skip_relocation, catalina:       "420b866883a73bc7fd2dff37105f09805b4d9f983aee5aec4583dd14a68e609f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e247e97968a140a0ce04a70e3b750e1c6d7e8f50b402fb712cefd20837cfc27a"
  end

  depends_on "go" => :build

  def install
    %w[
      kepubify
      covergen
      seriesmeta
    ].each do |p|
      system "go", "build", *std_go_args(output: bin/p, ldflags: "-s -w -X main.version=#{version}"), "./cmd/#{p}"
    end
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/kepubify #{pdf} 2>&1", 1)
    assert_match "Error: invalid extension", output

    system bin/"kepubify", test_fixtures("test.epub")
    assert_predicate testpath/"test_converted.kepub.epub", :exist?
  end
end
