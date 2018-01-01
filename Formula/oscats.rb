class Oscats < Formula
  desc "Computerized adaptive testing system"
  homepage "https://code.google.com/archive/p/oscats/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/oscats/oscats-0.6.tar.gz"
  sha256 "2f7c88cdab6a2106085f7a3e5b1073c74f7d633728c76bd73efba5dc5657a604"
  revision 2

  bottle do
    cellar :any
    sha256 "0af1c79f43a2d2fd2fe4582477d9d9789b96d9bbb33c2adaa128c70dd7f838ad" => :high_sierra
    sha256 "756f81c2343a64876be9485bb046cca78030151e7f46e606ce9b68ffa07db63b" => :sierra
    sha256 "ebc36ad36c4943030c7ee58eec176461f93a2a02f8a5d6484239c0968ad94e51" => :el_capitan
    sha256 "e83b19660fe00ed2c05e228646a931ad3837dafd74855921da25009833d5f387" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gsl"
  depends_on "glib"
  depends_on "python" => :optional
  depends_on "pygobject" if build.with? "python"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--enable-python-bindings" if build.with? "python"
    system "./configure", *args
    system "make", "install"
  end
end
