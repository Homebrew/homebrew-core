class Halibut < Formula
  desc "Yet another free document preparation system"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/halibut/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/halibut/halibut-1.3/halibut-1.3.tar.gz"
  sha256 "aaa0f7696f17f74f42d97d0880aa088f5d68ed3079f3ed15d13b6e74909d3132"
  license all_of: ["MIT", :cannot_represent]
  head "https://git.tartarus.org/simon/halibut.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?halibut[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed4000bb616ed6fcf26b2cb79659a1fec79d6e6728b05be5b3f53c1dea03ae7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15128f8454d3cbfbe26c615f8a49daeeb3f7a6566be8f390370bf1b789ec3aa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b45d0f3af3aba76ea7e2b5e0c447f0ae7674db57330c2d03c6a6dc8e5ef9a53"
    sha256 cellar: :any_skip_relocation, ventura:        "bed49d04cdab196ff5554ee4d8a0f431407cbce92f2eccc5b97d2ae4bdb23ffd"
    sha256 cellar: :any_skip_relocation, monterey:       "edef3d404fd16343e22399f1f559d6b937585e4e6dbd6f2ff2a3a954f2147cba"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e224f4d6f3757b28c0620022e925ea494c8d416db51c9306c87aba7619f7c45"
    sha256 cellar: :any_skip_relocation, catalina:       "df8f9c9f491fe0ac2cb55271a2f578260833733dfc7ce3d9f88ee3c9c865c5ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b074c7854ab9c65b56a04c63512c77e8bae8958a2beb2f0eff3b791264fc354"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"sample.but").write("Hello, world!")
    system "#{bin}/halibut", "--html=sample.html", "sample.but"

    assert_match("<p>\nHello, world!\n<\/p>",
                 (testpath/"sample.html").read)
  end
end
