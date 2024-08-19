class Aliyunpan < Formula
  desc "Command-line client tool for Alibaba aDrive disk"
  homepage "https://github.com/tickstep/aliyunpan"
  url "https://github.com/tickstep/aliyunpan/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "390a298c7f429a7c47f82be9b666d8a4231b4d74724cb671de6cad25963cb6b9"
  license "Apache-2.0"
  head "https://github.com/tickstep/aliyunpan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe0582846d6cc82dbed07dc32676e9a860f7aafb0efcfa10e100b4b4924a9b19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe0582846d6cc82dbed07dc32676e9a860f7aafb0efcfa10e100b4b4924a9b19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe0582846d6cc82dbed07dc32676e9a860f7aafb0efcfa10e100b4b4924a9b19"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb2bc6105e6669ba6281b6c0fb0ca6642ec1d30515e028203b943e76caf645ce"
    sha256 cellar: :any_skip_relocation, ventura:        "cb2bc6105e6669ba6281b6c0fb0ca6642ec1d30515e028203b943e76caf645ce"
    sha256 cellar: :any_skip_relocation, monterey:       "cb2bc6105e6669ba6281b6c0fb0ca6642ec1d30515e028203b943e76caf645ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd0222b76cee305087787bcdd745102d274253fe64e19eb0fccbb7491a7940ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"aliyunpan", "run", "touch", "output.txt"
    assert_predicate testpath/"output.txt", :exist?
  end
end
