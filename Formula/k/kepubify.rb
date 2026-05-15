class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/pgaskin/kepubify/archive/refs/tags/v4.0.4.tar.gz"
  sha256 "a3bf118a8e871b989358cb598746efd6ff4e304cba02fd2960fe35404a586ed5"
  license "MIT"
  head "https://github.com/pgaskin/kepubify.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "da1335fcadc06a8d78cb713f1884ce2d37ea70f0d06240f79c5f50c6b08acf32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "29e8dc9bcdbb61a0f99ebf14a051b7022b216debcbf110352dd68904d935609e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8be21c3880319f056357894fc1f425efd3daf2375f126ab5395e5a4182c74c3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "254db72d4558093188d4b9e164494549590e7edfa6ec59923db9f73722d1d972"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "190fcf71bfa7069608000948821b08e64ebf230bef805c6285d365bf3bc22a04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "813a2a57f898d3146f374a6c77e15eeba052d434e78d881602d88e5cb8162d1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b3c3a7973aae7ff8579ed1e0cef31cf891d8d7e36defc7b1956bc01a21928f1"
    sha256 cellar: :any_skip_relocation, ventura:        "44e8ad81f4b4a79af66a6a342a61d2cc35f6fb7266ac7d31eb789761035c95c2"
    sha256 cellar: :any_skip_relocation, monterey:       "b9944734812a60b9fff0895d49385d3ce15321da417a292e23760ab31ac54135"
    sha256 cellar: :any_skip_relocation, big_sur:        "07e78d188d1c64ac4ab876f6afb18458419ac056c791c1e2227788136639c3d2"
    sha256 cellar: :any_skip_relocation, catalina:       "420b866883a73bc7fd2dff37105f09805b4d9f983aee5aec4583dd14a68e609f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "406aad8a55b14e3e28226b53d993daa92587a0ad936b0501371f6dd4f4f08330"
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
    assert_path_exists testpath/"test_converted.kepub.epub"
  end
end
