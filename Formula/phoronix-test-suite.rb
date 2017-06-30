class PhoronixTestSuite < Formula
  desc "Open-source automated testing/benchmarking software."
  homepage "https://www.phoronix-test-suite.com/"
  url "https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v7.2.1.tar.gz"
  sha256 "b235f2cfd2f4891a3aea83114d5766879303c3f95ae9b661eda7aa59cb17c381"

  bottle do
    cellar :any_skip_relocation
    sha256 "96c7846ced5089c34d2e83a79a701dba815cc131b0db183607bad27bffe0bff6" => :sierra
    sha256 "f05c1ba748ffa1fcfcdeecb4ebb518232074d300b131af0a7e7c421c513a41b5" => :el_capitan
    sha256 "f05c1ba748ffa1fcfcdeecb4ebb518232074d300b131af0a7e7c421c513a41b5" => :yosemite
  end

  def install
    system "./install-sh", prefix
    bash_completion.install "./pts-core/static/bash_completion"
  end

  test do
    assert_match "Trysil", shell_output("#{bin}/phoronix-test-suite version | grep -v ^$")
  end
end
