class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.36.tar.gz"
  sha256 "ae50d53690ae4bb2a99cd3146a6f642bd86c82502df6656d0e6d6268086fd6c4"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0acfabb077e2b0c8340b8140bcaad9b72bf478912cce5f08509547780e70347"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61503b7623625ce8322ebe6477a07c0638205d248c882115d85d06a61f68078d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84ad39fbbf098a06d8e10d61610f35b0af00358e27463d6b36e8eb34480fd604"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f113b50b439a873bf25ff7fe23b361c629c147505e34dafef39e7bf7d707bdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0f13ad2d7b542ccdd89287c8ceec940eb8ad10dcfa56a3cdf9040130290b314"
    sha256 cellar: :any,                 x86_64_linux:  "48f98380b55daca3445473feae2010e6f80f958b0058cab96de79ec9ec2065fe"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix

    generate_completions_from_executable(bin/"gauge", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "Plugins": [
          "html-report"
        ]
      }
    JSON

    system(bin/"gauge", "install")
    assert_path_exists testpath/".gauge/plugins"

    system(bin/"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
