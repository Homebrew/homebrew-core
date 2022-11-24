class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v1.2.2",
      revision: "6815b679c1b182bace25abc16de5afb494777283"
  license "Apache-2.0"
  head "https://github.com/openservicemesh/osm.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a67e4b9ceeb29ada0d24bd724f963467e0d425adbcdffba389bb488fac366635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcf117a35ed020fc6d409e738aff9acd67b21f71d94c0651f2d40bf4b75cc2bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0f7248d81082f5fdbbb39af629ed8118d6cff3fabc6c5385bcb9beeafdfa677"
    sha256 cellar: :any_skip_relocation, ventura:        "1b7b8a5565d55389f31809551eb02742c33af0c2befc190117394657dcf6e44d"
    sha256 cellar: :any_skip_relocation, monterey:       "8e3877838bf5232de9b27073ffa82d540f3211b2309becc5223d497c89d0441c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1b8f61bc1053eceb98f728676e270546932dbb7ff46a5518082eb0b8b854efb"
    sha256 cellar: :any_skip_relocation, catalina:       "626c9e2921e24712e50100fc5e736b49158a7111c31213d93bead8dc09ca20e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8adb5b0f0d90c14e528aafad1d5f89c46f5d4ac91ab87cda80b0bc3ff155f8d0"
  end

  depends_on "go" => :build
  depends_on "helm" => :build

  def install
    ENV["VERSION"] = "v"+version unless build.head?
    ENV["BUILD_DATE"] = time.strftime("%Y-%m-%d-%H:%M")
    system "make", "build-osm"
    bin.install "bin/osm"

    generate_completions_from_executable(bin/"osm", "completion")
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version:\"v#{version}\"", shell_output("#{bin}/osm version 2>&1", 1)
  end
end
