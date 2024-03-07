class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "98e17818381e23f7ff3f8cdb61cd47a37e11efd55b5b4c476f958d6485a45ce2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98fc4b5a4d6338ed8f324c3c8af8e0c2908dbc85bdfc7216955bafea4b99110b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "210e91db27dce657d744dabdeeda9b341503a28e4a8f44be5f89198e73e0dcbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b09fdb132995979c521ce96adc4a6ad51895bc63e1effbffe5eac82c8c81817d"
    sha256 cellar: :any_skip_relocation, sonoma:         "188dc20a2aa97e0a48cab0b3edfce81dccac303351d0b55716c6035e6d4606fc"
    sha256 cellar: :any_skip_relocation, ventura:        "b942a606d0a784013b2516ce357a76fc7fc298f6d5c4b4fbb4c0fd5437813795"
    sha256 cellar: :any_skip_relocation, monterey:       "1aaef701eb89bceb4ab1db4373ca9b7091109bc92b635c39dab0c27ff80cb9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4449dc88432171bea8e292f1dd472d7d0ce42848e57f27a9a9f8376a910b14cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/GoogleCloudPlatform/berglas/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berglas -v")

    out = shell_output("#{bin}/berglas list -l info homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
