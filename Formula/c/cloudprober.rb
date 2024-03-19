class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "a666be1c5a2904df57464088114e44411cb4e0670c9f0f154e0bfbb5535457c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd348333219f96140b4a20bfb9b4ea8741409c0799741f9c457e8e80fa042a0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "313ed270af5f57deb84459da16e2edfa5206858a7863eec2e003b9fd79cf79a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6df8976311752db2577e4fa1640548a28530b4f5f28b4f9d6c89f1b6c75bd6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c5c114f97fdc424ba1fe01c09f9e7c86a75ad9ea1629bbe2a4de26c8994288b"
    sha256 cellar: :any_skip_relocation, ventura:        "df29bcef78d20f741c04754497ae5c6ecc5f3018567fb3d3aca01ef5c350fbbd"
    sha256 cellar: :any_skip_relocation, monterey:       "e5f4e11f29cb3987fb7f5813bdc5caf3c34b4b5fb28717bd8631cc8426916eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0890c43b071df5f6ba39f7dfdf8958b5f6e9d48dff28b4e7cd7cae16ddf1b6be"
  end

  depends_on "go" => :build

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    io = IO.popen("#{bin}/cloudprober --logtostderr", err: [:child, :out])
    io.any? do |line|
      line.include?("Initialized status surfacer")
    end
  end
end
