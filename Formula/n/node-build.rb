class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "0989b10bd5e8995c39bb860c2c16e83e91cf44331f962d33d74bc0482ecc39de"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a36c8197b5314925eda575d61ca7584f8a78371577d6caa6f98254556e4adc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a36c8197b5314925eda575d61ca7584f8a78371577d6caa6f98254556e4adc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a36c8197b5314925eda575d61ca7584f8a78371577d6caa6f98254556e4adc6"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a36c8197b5314925eda575d61ca7584f8a78371577d6caa6f98254556e4adc6"
    sha256 cellar: :any_skip_relocation, ventura:        "1a36c8197b5314925eda575d61ca7584f8a78371577d6caa6f98254556e4adc6"
    sha256 cellar: :any_skip_relocation, monterey:       "1a36c8197b5314925eda575d61ca7584f8a78371577d6caa6f98254556e4adc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "227360f5affdd7011b9c9a2286445f232bd87636fe82d09092ff8e43e47a3973"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end
