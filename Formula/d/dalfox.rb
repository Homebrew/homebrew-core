class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://github.com/hahwul/dalfox/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "3bb78fcdcfd620aebb5f7488770ee4df7c7fb6448181963f290e60a1cba95459"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91f55801c696f298971522b7ce6d824a9a1df13b047916ae74f0ab5316ee3d64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91f55801c696f298971522b7ce6d824a9a1df13b047916ae74f0ab5316ee3d64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91f55801c696f298971522b7ce6d824a9a1df13b047916ae74f0ab5316ee3d64"
    sha256 cellar: :any_skip_relocation, sonoma:        "d89e7889cfb98452513664f667326fc9d75cca2ac01c1f3efe70703ee9f4a81e"
    sha256 cellar: :any_skip_relocation, ventura:       "d89e7889cfb98452513664f667326fc9d75cca2ac01c1f3efe70703ee9f4a81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f947d564a27d70be00487e9ba33ba79e681e6f6ad230f2e635ad32aef925e5f4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"dalfox", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox version 2>&1")

    url = "http://testphp.vulnweb.com/listproducts.php?cat=123&artist=123&asdf=ff"
    output = shell_output("#{bin}/dalfox url \"#{url}\" 2>&1")
    assert_match "Finish Scan!", output
  end
end
