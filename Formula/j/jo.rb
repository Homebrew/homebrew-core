class Jo < Formula
  desc "JSON output from a shell"
  homepage "https://github.com/jpmens/jo"
  url "https://github.com/jpmens/jo/releases/download/1.9/jo-1.9.tar.gz"
  sha256 "0195cd6f2a41103c21544e99cd9517b0bce2d2dc8cde31a34867977f8a19c79f"
  license all_of: ["GPL-2.0-or-later", "MIT"]

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4aab533e9fa8e5cdca40d4275cae1c956d9de52e30bfa02ac30092562a7f40d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92ff2f6f6fb52d6ceb30e458a3a402eb49094671947f028a2abe78dc822ffd58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd76f20d3d909585dd3341f1776e8fd9869c4c52d06f67e7d8583a0e230846e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f76a57de3814c4a9b5fb87fb9e63e6d20cca457a94467783033b27d293229bc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9698e023bb10fc36d11eab06ef66d5abf087b0cb247c13ac363fd97afa2cdf6f"
    sha256 cellar: :any_skip_relocation, ventura:       "c654746fff530ccfe66809a4eff3d15f0f29cee2fed75abf7e1296a4c539321f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4aca359801025e506796ecf3bd3aa58077b599244f6d210e1562c5354420eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd4209b90b9732f0602cdbbaf598f1cc61676dcdb2fc7e0ee7c094a290555fad"
  end

  head do
    url "https://github.com/jpmens/jo.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    bash_completion.install bash_completion/"jo.bash" => "jo"
  end

  test do
    assert_equal %Q({"success":true,"result":"pass"}\n), shell_output("#{bin}/jo success=true result=pass")
  end
end
