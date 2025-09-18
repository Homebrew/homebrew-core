class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://jqlang.github.io/jq/"
  url "https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-1.8.1.tar.gz"
  sha256 "2be64e7129cecb11d5906290eba10af694fb9e3e7f9fc208a311dc33ca837eb0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^(?:jq[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "90b0fe4ad51959380f16fe8d84c5be8ab525478c32f1f7034c72d99de2442c9b"
    sha256 cellar: :any,                 arm64_sequoia: "d7bce557bb82addd6cf01b8bb758d373ee11cb6671e4d7b1dc2a2c89816bcc32"
    sha256 cellar: :any,                 arm64_sonoma:  "147e512951120ec6f10a36a857c84f5f3300fd33b3d6bcce2f2162b10b0481aa"
    sha256 cellar: :any,                 arm64_ventura: "efd141679d5a7a57797fc8866aa8f2200b08622b141877117f9b9204b27f6e87"
    sha256 cellar: :any,                 sonoma:        "a1a5f487f1840d9a18abdecdf1c6c5a5385917725c6ba88f7f819ac5f4cfa801"
    sha256 cellar: :any,                 ventura:       "1b5303b052e245affedf2e7b1c59caf4424b1e5b3d65de186424dc8dcf6b1ee7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "274b391020473ad15697b0eaf0dc7e44a57312e7eaa7642e1bc8426ca9c0a54d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82883e1f3b674759d0e3d0c37e6805c0f91e3886f3e40c7ebc57f1e0174dfbe7"
  end

  head do
    url "https://github.com/jqlang/jq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-maintainer-mode"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
