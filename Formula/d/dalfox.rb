class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://github.com/hahwul/dalfox/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "cec08c3256b072cf6aa1408aa4e0a111baad4a069601fdc7502119afe61077ee"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f6fc3493d1989bd64cff86554e6be1c0d397b966b88000041917810cce12764"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f6fc3493d1989bd64cff86554e6be1c0d397b966b88000041917810cce12764"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f6fc3493d1989bd64cff86554e6be1c0d397b966b88000041917810cce12764"
    sha256 cellar: :any_skip_relocation, sonoma:        "88a35ff5ec2a4c7db0b451fbd4ad20d45346ee10386841a2270c45d6a47d0766"
    sha256 cellar: :any_skip_relocation, ventura:       "88a35ff5ec2a4c7db0b451fbd4ad20d45346ee10386841a2270c45d6a47d0766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd1a1b8b5b9d015f06704bbe902bb8b9183806c425bd26aa34dce39e84916250"
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
