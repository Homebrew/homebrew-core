class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.12.2.tar.gz"
  sha256 "f185a44f46fe39688493008d47debfe63ea7cd26464f522df292c62539b8ca8d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "343873dab5d9ecde9c71bca32cd2601e4becacdd152b99f7dc0179f0ac83051d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db904a1ef7ebd44632c96eb6effdae270bd2189ee4233c3f956787ca2e6b6a2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0b11a8f6833c0316e2271856e0b96563f0b989e6ccaefbc1a3991216df952da"
    sha256 cellar: :any_skip_relocation, ventura:        "b8049ef246d8f051fff6cef8efacc1213668aa5d00e2d11058f3269010604118"
    sha256 cellar: :any_skip_relocation, monterey:       "493a96a0c313dd5dfc39c9be1b0ddcdec2cd01bb7163f5d3a4a8bfdbd3acc541"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f08e48e58438c895d86986041cfb1a3341ca182d3eef04a1780dd9a2af2c360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca6e3507d4a5e31a725e576a047264490577a476ab04bc42f0463344a509fdbd"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end
