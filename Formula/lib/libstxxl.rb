class Libstxxl < Formula
  desc "C++ implementation of STL for extra large data sets"
  homepage "https://stxxl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/stxxl/stxxl/1.4.1/stxxl-1.4.1.tar.gz"
  sha256 "92789d60cd6eca5c37536235eefae06ad3714781ab5e7eec7794b1c10ace67ac"
  license "BSL-1.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e9a97733a67a95ca7bcaeb336a2573cf54c7110163448db00a1d27e98d49c364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "30d099063deeb524f2ebe459a34fccb9236780abee29b1a8487f131922b015b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fa5cbb1eb4ac3bf9d3603d0eb56d2e75db5b4962ed87c625f45deb988713a6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c553b5d40fc2b5c081634ce666570017b82f4c74c0f5915173bd9024d959de1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e487af039d6286b34dc4aeac3c0eaba10668054b33a368e54f9cb8647834ed55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8454123ffed231405d684ed18c2ef1a0ab1bd118d74614748a5b5df23d8bb5fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "8974e02f766e33348b526ff4545441e9edc78dfb55847b996c115b53a8811211"
    sha256 cellar: :any_skip_relocation, ventura:        "2da4cce955e2b91e309712edd7e0271ff7671e3b472536972d802102547ba5a3"
    sha256 cellar: :any_skip_relocation, monterey:       "5916828893681e83b360fbd3638499592b65f39a546b64156aac85bf52a90550"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3f8dceb4e0a1716a2c193daf4b5eeb4ae3e8e96224bdc78ae8f74c2a3059152"
    sha256 cellar: :any_skip_relocation, catalina:       "b4d5ef6b70735617973eb1f45214b11e3e6baec242bc6aa5ba9ed4da1834f6ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "830762e021660cbe0143faa6737a34aa03104344f17f561b6bbabf5befaa799b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8651bc71eeb58d5fc34d8b934576ceec8d7735575c595e50e8dd8e4d2dc84ae9"
  end

  depends_on "cmake" => :build

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
end
