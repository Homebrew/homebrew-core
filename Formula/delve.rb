class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.20.1.tar.gz"
  sha256 "a10aa97d3f6b6219877a73dd305d511442ad0caab740de76fc005796a480de93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb2302aaef88f2b306ba590128920423f4cf024068a90fbf8d254866fcfa1e68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8383c4e4fc3613b9542f4644c6249846807420dbd9a4ff46f35bfcfe289de8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "827cb79afcffac49eca03f2fdc9647c4736bc6f1c3e2e370efe0f16839523363"
    sha256 cellar: :any_skip_relocation, ventura:        "3094768370c25d688a36c3eb8ffafdbd05b5aff4e9316fda5d7a2b59f874d111"
    sha256 cellar: :any_skip_relocation, monterey:       "73caa50429a57f4edde1da1db8b08733276abd2044710e8c946bb4f9a1e1d381"
    sha256 cellar: :any_skip_relocation, big_sur:        "007349a9417e16ceda0455fb49b7ef4bbe2b14824c744b89bc82400ae02d0019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46c60883cfaccd53283458c485fd3e10ad0d7a1401f7484cf50df7596932d30a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
