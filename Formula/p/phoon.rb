class Phoon < Formula
  desc "Displays current or specified phase of the moon via ASCII art"
  homepage "https://www.acme.com/software/phoon/"
  url "https://www.acme.com/software/phoon/phoon_14Aug2014.tar.gz"
  version "20140814"
  sha256 "bad9b5e37ccaf76a10391cc1fa4aff9654e54814be652b443853706db18ad7c1"
  license "BSD-2-Clause"
  version_scheme 1

  # We check the site using HTTP (rather than HTTPS) because this server
  # produces the following cURL error on our Ubuntu CI:
  #   curl: (56) GnuTLS recv error (-110): The TLS connection was non-properly
  #   terminated.
  # If/when this is resolved, we can update this to use `url :homepage`.
  livecheck do
    url "http://www.acme.com/software/phoon/"
    regex(/href=.*?phoon[._-]v?(\d{1,2}[a-z]+\d{2,4})\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| Date.parse(match.first)&.strftime("%Y%m%d") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "636b515de152863a3694ddd5cab6745302e40fc8d649cd14bcf2b1debc5c2ba6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "eea7e8ab443ec3e74f55f9b0572fc1fdb041d4a484f05c523820d3c9c510d646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b1fb75a7e0219b4f893f0ffc74791a27e82e95e127e6f8c66680b046d6f8a72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd15d230ce1c25ac23caf064b0468fcbb779b3c0ba264410f59f3d8796c9f0c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16e0d7747e8d27e1d2070e9c0a977e978df8e050fcfec31ad4da2363450ac297"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ffb866ee12dee9890eb0ad36b0bc1e721bba69b631951fbeba3f2fb20a87168"
    sha256 cellar: :any_skip_relocation, sonoma:         "de8a63bb9fa807b81f47b3b45f042d0829c7b8d2af9651a842c0098f2fed3948"
    sha256 cellar: :any_skip_relocation, ventura:        "503f0d23d27f7016072550d71117f16691c827f1c9f8502bd52ec1562178be30"
    sha256 cellar: :any_skip_relocation, monterey:       "b4beab04ea220698a14dc6a0f104205e21f5e3b1af4846b849a1398b51c667e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "40dc9f71c308e04063cf566ba3ba64459d781f2795d0fa4aadee860768a763ab"
    sha256 cellar: :any_skip_relocation, catalina:       "27ac5801ac5c5b411b587df1ec799acca76c3acd3a0a02a193a187d07ee76747"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "751a25b30911bd21075babf88ea8311ff1059a5b93ff08cdde9fadcf50b4c2c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c14a5311b93a01cfe4857784708ae9e6397525c07b07ca34f26b58d5dddc6f93"
  end

  def install
    system "make"
    bin.install "phoon"
    man1.install "phoon.1"
  end

  test do
    system bin/"phoon"
  end
end
