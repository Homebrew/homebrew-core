class Knock < Formula
  desc "Port-knock server"
  homepage "https://github.com/jvinet/knock"
  url "https://github.com/jvinet/knock/releases/download/v0.8/knock-0.8.tar.gz"
  sha256 "698d8c965624ea2ecb1e3df4524ed05afe387f6d20ded1e8a231209ad48169c7"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ccb817325238596bec85da5437875f0abb6080f8572406e0a76a1badeb3c922e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6918a15821559b226ee8e3844a439277a1cf6b4dcd6fa503fd71531fe541fe8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0705f9179784dc82526bc20a47df2b3a39b1b5e476cca49d4406c9c0e3f1ea1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "326959f0e368e3b38816abdc5b45d483d1c4d46f0d26775171bd7d5ebeaa059d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f84095e2b3b16af1f3d2263b79dd3432f9dbc9db27654377d520fdb54a0c520"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81bcc7e4f700f88fd52678bcb97fe0eddf0a562e28bd406268ae263e286903dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cffa8fa11e0df3dd002848ae504e67dec0064e8d8d37787020a5b3b068e14f7"
    sha256 cellar: :any_skip_relocation, ventura:        "765d3a0f6ae6560d5c274cda7330e50faaa3412d11251594a8463b5acd9a0539"
    sha256 cellar: :any_skip_relocation, monterey:       "964a0505b7d815efb5be3a9ecf3e935d19e07e8fb9245fc292dda30501d089cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8d423345658b70c35b16a032ace493f1da244144dbfe0f4c4b0ed79ce0ac560"
    sha256 cellar: :any_skip_relocation, catalina:       "2c9a3167f4b08e9b4ed890f6cc165eda8e813da9c911e741fd9cdb5d3742de31"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cb2b4fc229f51debb0a56914b078a7c10f9ce2bd479e14104bf2c8d8e520abdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92ee3bfd7171b2fd896bda24b35ccb710365acf17e8c87b01d6a119a5133d996"
  end

  head do
    url "https://github.com/jvinet/knock.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "libpcap"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"knock", "localhost", "123:tcp"
  end
end
