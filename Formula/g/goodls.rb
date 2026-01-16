class Goodls < Formula
  desc "CLI tool to download shared files and folders from Google Drive"
  homepage "https://github.com/tanaikech/goodls"
  url "https://github.com/tanaikech/goodls/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "1131c18b9677b8faa87140806f2f9548572a72f710ed3564a85f01085b801d98"
  license "MIT"
  head "https://github.com/tanaikech/goodls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb271f1eea59804e392908cff1ac2387179f00e0e9a02fdc8bf51e6ed464f14d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcaf66196cb83773ee01ecbafb2db92b9640641a90ba38388ea60904240beb4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcaf66196cb83773ee01ecbafb2db92b9640641a90ba38388ea60904240beb4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcaf66196cb83773ee01ecbafb2db92b9640641a90ba38388ea60904240beb4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "16161f75d9eabbe1263b7115aedd206dc84581c7e20f6775ad2d3f51ae355f2c"
    sha256 cellar: :any_skip_relocation, ventura:       "16161f75d9eabbe1263b7115aedd206dc84581c7e20f6775ad2d3f51ae355f2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9480958e7d8d1901b2b4f21204a54a53562d089f4298d36521201cdb03c7ce0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "590b91e949cadbf80fdeaca615297fa72ed5afd864fa762fc584d49368958390"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goodls --version")

    expected = if OS.mac?
      "URL is wrong"
    else
      "no URL data"
    end
    assert_match expected, shell_output("#{bin}/goodls -u https://drive.google.com/file/d/1dummyURL 2>&1", 1)
  end
end
