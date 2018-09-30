class Le < Formula
  desc "Text editor with block and binary operations"
  homepage "https://github.com/lavv17/le"
  url "http://lav.yar.ru/download/le/le-1.16.5.tar.xz"
  sha256 "258d586f83e8abd55144dc3f09d9ddaf6ef55e8a90543fdb0932fb77d089dd78"

  bottle do
    sha256 "8f923693a632a447888ac16d766e2318aed6af1400663de3a1ad9f27da850109" => :mojave
    sha256 "614516096f3fa5bb72f68fa747e611401098239d72c7e31274b1fdf41a4d0c59" => :high_sierra
    sha256 "bb670b11e7bf2813cf89cf35ad7e04b67c330cef6c1c07ab5b65fbe1879af67a" => :sierra
    sha256 "285e9bf7c3debedb6286ca34971d939c673a35d4553817fdc48dc915e649ba0c" => :el_capitan
    sha256 "82e83a7c1f1a030429b013d4fd138327003605193e683e092924e80b5e02bf8e" => :yosemite
  end

  conflicts_with "logentries", :because => "both install a le binary"

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/le --help", 1)
  end
end
