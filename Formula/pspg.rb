class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.0.1.tar.gz"
  sha256 "852314ed8c0efbfdc58989274b865c042c5a717849a6d4243eadbce619b88fd7"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "75b87907880198c7b69a6e26dfc1c1f7653b669623f9a61b9f73ee42f08f647c"
    sha256 cellar: :any, big_sur:       "46c0df184bb173ac1c8cad14e830aad256f6bf7d6414ba70ed20e9db651cf20b"
    sha256 cellar: :any, catalina:      "a7cfebf8e348c4e9c4ddfa1aec1f1b3f78c44787a90c903fdb504762a21f7e5e"
    sha256 cellar: :any, mojave:        "102831b234a686e284d51174feb88b8af8b3ec2916854f8793fbf1690a3bb38b"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
