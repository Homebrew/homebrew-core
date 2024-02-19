class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "c9006b2acf159d54fd00a1713422ab70914dae87270b4f44d05edab526199e20"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8342b5a488657ba7a82f5e21d83730fbf4b9571632eb4eb7eb2ce6d84500854b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c934acc1215ff0a026307333272f2b93667a6bce3b3b2b4b20418c57b77de790"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4ec0d231eada5dd08156bf48fb12d634314cd2c73abccc9256537669409d37f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e744c01c93efc2f259af48b0554db58fdeb0a962b226c86b4a71ad0a700c4795"
    sha256 cellar: :any_skip_relocation, ventura:        "9e8b4b1c1b2325dcb894676493bcd233bc822fe8e140447a9bbae8255ceb6ca6"
    sha256 cellar: :any_skip_relocation, monterey:       "388165e854299342a217c317c886227b8f0299acf980abb4db78da5d0cc8891c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b65cf89fe05ae692d50c5873dc9ba97609adf60f386d6bb0e4682ca34ed576df"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
  end

  def install
    if OS.mac?
      system "make", "osxkeychain"
      bin.install "bin/build/docker-credential-osxkeychain"
    else
      system "make", "pass"
      system "make", "secretservice"
      bin.install "bin/build/docker-credential-pass"
      bin.install "bin/build/docker-credential-secretservice"
    end
  end

  test do
    if OS.mac?
      run_output = shell_output("#{bin}/docker-credential-osxkeychain", 1)
      assert_match "Usage: docker-credential-osxkeychain", run_output
    else
      run_output = shell_output("#{bin}/docker-credential-pass list")
      assert_match "{}", run_output

      run_output = shell_output("#{bin}/docker-credential-secretservice list", 1)
      assert_match "Cannot autolaunch D-Bus without X11", run_output
    end
  end
end
