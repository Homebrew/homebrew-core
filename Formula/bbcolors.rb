class Bbcolors < Formula
  desc "Save and load color schemes for BBEdit and TextWrangler"
  homepage "https://daringfireball.net/projects/bbcolors/"
  url "https://daringfireball.net/projects/downloads/bbcolors_1.0.1.zip"
  sha256 "6ea07b365af1eb5f7fb9e68e4648eec24a1ee32157eb8c4a51370597308ba085"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "eccd746ed946749acadc63ef4e6ff652f2c1372459f1bf586acce1590729cc75"
    sha256 cellar: :any_skip_relocation, mojave:      "3eb2e91111f491b315d5bb077dacdf9dd03fa74a585ba780c59bdc071c104fe2"
    sha256 cellar: :any_skip_relocation, high_sierra: "b54a89cbcfcb6a0fb0b3c1279884f1fa54196e2c22a19424ea95827f419030d9"
    sha256 cellar: :any_skip_relocation, sierra:      "cdc81c86b829ba9e051d693bccdb821ed78a8dc3a5df644fc156bfcd700d5686"
    sha256 cellar: :any_skip_relocation, el_capitan:  "2a713dae009e44685d1ef02b01d5202a24087129dab70366d2e30800b7dfb9cb"
    sha256 cellar: :any_skip_relocation, yosemite:    "506d7f82fa38e1f694550be30a29554b8ecc8b303d47e9bb4fcadfc534ac55c7"
  end

  disable! date: "2020-12-08", because: :unmaintained

  def install
    bin.install "bbcolors"
  end

  test do
    (testpath/"Library/Application Support/BBColors").mkpath
    system "#{bin}/bbcolors", "-list"
  end
end
