class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.4.3.tar.gz"
  sha256 "02a620a7ff8388c57d6f6e0941eecc10d0c23ab47c45942fb52f64a6245c44f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7780c806200754f059d5b0308c05e754f8178732094db56778e5dd84e6e3be1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b133142f86e93c4da293e5313d225235078de8f3e08baddecb3eb3b5675e6f2"
    sha256 cellar: :any_skip_relocation, monterey:       "dafc34d46e7011e870a0be988b5f95622dc2d39d35da161137b2571ae3c48f30"
    sha256 cellar: :any_skip_relocation, big_sur:        "1290a57ebb6ba3bd53664969513f457c8f85b7c2f543211f08fb72e196abe819"
    sha256 cellar: :any_skip_relocation, catalina:       "5d8c5f99fa4e605adc5268058c31ef8cd109e763e548679e63d6efbb63412941"
    sha256 cellar: :any_skip_relocation, mojave:         "76c996cfd7d4ae8de4fcf9693cc7d1c7e61ea35cb9e730e7e5d005d2b09aa527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcd04c6ce5607217f0bae7918c246d7b8482906676067320ecf4592c17ff3260"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", * std_cmake_args
      system "make", "install"
    end
    pkgshare.install "testdata/cube_att.ply"
  end

  test do
    system "#{bin}/draco_encoder", "-i", "#{pkgshare}/cube_att.ply",
           "-o", "cube_att.drc"
    assert_predicate testpath/"cube_att.drc", :exist?
  end
end
