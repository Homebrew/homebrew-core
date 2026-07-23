class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "78ed8e36051145d523c9a7be878f7af82bd26405ff28d1ebdcae07efe4c52fdf"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47a191414cb84664b08757a83f87219527b21de799bde1468c7f25926a6405f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc55a14fcc0a63bda967df121f18473f00600c1733425ef0a2b6989eb4c827cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc3dc304a38ce164d9308bea986c1c16bb811cb67920de37f55e1ad14408b2ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "86374422c8a31cfdaea125a1ad0adae1499adce6dcdcc6ec1de00d490fc444cf"
    sha256 cellar: :any,                 arm64_linux:   "e0e2a2f05c849cc72c53dd3da6024ab773958d42bd78dc5de620bda820b68ac2"
    sha256 cellar: :any,                 x86_64_linux:  "32efac635b56190c54946a7824eb06105180017341a266768d710b45ead1ba5e"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
