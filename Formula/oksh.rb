class Oksh < Formula
  desc "Portable OpenBSD ksh, based on the public domain Korn shell (pdksh)"
  homepage "https://github.com/ibara/oksh"
  url "https://github.com/ibara/oksh/releases/download/oksh-7.2/oksh-7.2.tar.gz"
  sha256 "3340ca98b1d5a2800ebe7dba75312d8a4971a3fcff20fcd0d0ec5cf7b719427e"
  license all_of: [:public_domain, "BSD-3-Clause", "ISC"]
  head "https://github.com/ibara/oksh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e258ac45b9617470688d9372662294980b1695a15c65ef30e322a8d3e2349c53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92bd0170e4c7084bbd99ffd3f690abff73aafc62cb1d1f39b512bc94cc7db2d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64acdda6e703c41d5f2c4f4ad18e726e39d10eb0b691c5817e01cb5ddc50deef"
    sha256 cellar: :any_skip_relocation, ventura:        "b25395d101de87ec0a49ec8863e7f0d563570334f97c210d0648ea5a1af93909"
    sha256 cellar: :any_skip_relocation, monterey:       "31483e6b27d67a84e51be25126245200766863302f6db893c638f3f368d0eae1"
    sha256 cellar: :any_skip_relocation, big_sur:        "fab43495e25b0687f76339bfa26b9f0e32399a66cd40507a5d3a07e5ffd947b2"
    sha256 cellar: :any_skip_relocation, catalina:       "2338af0e8ef621b614ef57cce9bea4776079ac6205cf3861d89990fde13ec717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0228121955c1714503d0302924218e9e8f868298de94de6435f15dc8d02bd191"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/oksh -c \"echo -n hello\"")
  end
end
