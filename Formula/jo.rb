class Jo < Formula
  desc "JSON output from a shell"
  homepage "https://github.com/jpmens/jo"
  url "https://github.com/jpmens/jo/releases/download/1.9/jo-1.9.tar.gz"
  sha256 "0195cd6f2a41103c21544e99cd9517b0bce2d2dc8cde31a34867977f8a19c79f"
  license all_of: ["GPL-2.0-or-later", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cff2c3168526423e589192b36bd2bef9dd123f5d960ce65e9ffbcae36bcbf898"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b07931afb2f5184b579fe97bedc3da888b4113632d42b30122aa9e877bce9e22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11d1fa55ba7cdf4228ddabd9441517f5e65eceeb5912e23aede7499059545504"
    sha256 cellar: :any_skip_relocation, ventura:        "4bdc4df3521ec5cfc62cdb56fc252f8f3db8f1633002625059615de4a77ab0b9"
    sha256 cellar: :any_skip_relocation, monterey:       "682e771556543d18f7bd82384a1a01690d5c8173b115dbeaa92ae62cea2bbe7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8711cdb2d031d165a1967f68dbd2991a61515d35e35973c77547c26154000bd4"
    sha256 cellar: :any_skip_relocation, catalina:       "2f0bfbd2e270b4e41c65dd46d627752103ba27a75ddf5ffe3cbb76b48a9d4109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7635a8a7f0174e957d9600fa87e350bf245caa61bda573a19b69dca3c488bb9d"
  end

  head do
    url "https://github.com/jpmens/jo.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal %Q({"success":true,"result":"pass"}\n), pipe_output("#{bin}/jo success=true result=pass")
  end
end
