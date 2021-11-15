class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://github.com/mattn/goreman/archive/v0.3.8.tar.gz"
  sha256 "b3d14310e84103d7557505dbd0d4649109c0574a3677a459683fba2721aedfc6"
  license "MIT"
  head "https://github.com/mattn/goreman.git"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c848d97a3dd01b0766e9e150f1ec348bc678e09023f52beaa01fd37376a844ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f01e123072da262770e58be58d02cd4420109afc60ad4a9b3e40736f252ca91"
    sha256 cellar: :any_skip_relocation, monterey:       "a4b7a2a1678d86ee83ead87697ab42c15493a80d367a642d9aec30359b3e59b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "379ff164b5c3f6cd46a38fcbee2763bf5720f968999752aa361eb12c9fc280fa"
    sha256 cellar: :any_skip_relocation, catalina:       "9659197993188b2456b33a701f636bcbde07f8585a8bb3409c13ed85296fe687"
    sha256 cellar: :any_skip_relocation, mojave:         "81050a32c568ca72e553e74e1758b9767cfe938252c94bffd9c87b7151a6c29a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2a5eb0ed131894cccafe025849ac67541c18658e4658fb3a33cddc0bb0a71c7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"goreman"
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_predicate testpath/"goreman-homebrew-test.out", :exist?
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end
