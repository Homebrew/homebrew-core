class Cassowary < Formula
  desc "Modern cross-platform HTTP load-testing tool written in Go"
  homepage "https://github.com/rogerwelin/cassowary"
  url "https://github.com/rogerwelin/cassowary/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "48f573bbb2b62cd00da68be7d79a8e9b2767ec8e512d6e0a7765c7b18081129f"
  license "MIT"
  head "https://github.com/rogerwelin/cassowary.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e8ed989ef0f8b0694a4975aa2ba038dbe078e737c339cb0841b78431ea1df22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af786d30b88554a9252cf4eafc40831f1fd796a03a76f4ee669ed565b1e526fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af786d30b88554a9252cf4eafc40831f1fd796a03a76f4ee669ed565b1e526fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af786d30b88554a9252cf4eafc40831f1fd796a03a76f4ee669ed565b1e526fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "58016ae507acc0044612858a240461d94175a7cd772a5e2ba9290c790ecd9455"
    sha256 cellar: :any_skip_relocation, ventura:       "58016ae507acc0044612858a240461d94175a7cd772a5e2ba9290c790ecd9455"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f1affd04f536b966c985fb11c1a1466f6fe7b9cb73fd8460fbba2e80648e04d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7668f4bb871a15e8e62e10502746152ba54fba5ae49591de97281edc53c9c2b9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/cassowary"
  end

  test do
    system(bin/"cassowary", "run", "-u", "http://www.example.com", "-c", "10", "-n", "100", "--json-metrics")
    assert_match "\"base_url\":\"http://www.example.com\"", File.read("#{testpath}/out.json")

    assert_match version.to_s, shell_output("#{bin}/cassowary --version")
  end
end
