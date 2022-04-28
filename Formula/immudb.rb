class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v1.2.4.tar.gz"
  sha256 "dd7f7ef1bae8d34ebaa1bb8d1099a1b0809dd6bac0d36fdc279139087dcedb79"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c8b1fb70f7f9411d9b731769b58e30bd4fc4e7b97956b972bb1a1b1eadf728d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1d1ea9ebd9d1ca9005310fede33d1a412ae5da3ae6255e57dde60a06969feb0"
    sha256 cellar: :any_skip_relocation, monterey:       "7abcc3c0d0ddb5daace0e2abefae4c5970a134a002dd867418e6aef17ef3479c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7882618fdd336a379c0369014ecf858a2185b05c45106df2b1f15714abcc9e3"
    sha256 cellar: :any_skip_relocation, catalina:       "dee21b9d761a2e1c9224ac11020f9d2613d68d68dc1a7e6baddc69149d008450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd851128b70ae96ad5c0a69fd239681e59ac17ee2b9f2a50bea467ea78b7d5e"
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    bin.install %w[immudb immuclient immuadmin]
  end

  def post_install
    (var/"immudb").mkpath
  end

  service do
    run opt_bin/"immudb"
    keep_alive true
    error_log_path var/"log/immudb.log"
    log_path var/"log/immudb.log"
    working_dir var/"immudb"
  end

  test do
    port = free_port

    fork do
      exec bin/"immudb", "--port=#{port}"
    end
    sleep 3

    assert_match "immuclient", shell_output("#{bin}/immuclient version")
    assert_match "immuadmin", shell_output("#{bin}/immuadmin version")
  end
end
