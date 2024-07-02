class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https://www.apibuilder.io"
  url "https://github.com/apicollective/apibuilder-cli/archive/refs/tags/0.1.49.tar.gz"
  sha256 "b6bd4a33554413eb63f9f3f2c8c5b0ba1926893aca8575b537602fac8bfb532d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79672b8fc92835089a5ce4e1ac85aca4dddea758b5201b870e077cb5ac8e0553"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79672b8fc92835089a5ce4e1ac85aca4dddea758b5201b870e077cb5ac8e0553"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79672b8fc92835089a5ce4e1ac85aca4dddea758b5201b870e077cb5ac8e0553"
    sha256 cellar: :any_skip_relocation, sonoma:         "79672b8fc92835089a5ce4e1ac85aca4dddea758b5201b870e077cb5ac8e0553"
    sha256 cellar: :any_skip_relocation, ventura:        "79672b8fc92835089a5ce4e1ac85aca4dddea758b5201b870e077cb5ac8e0553"
    sha256 cellar: :any_skip_relocation, monterey:       "79672b8fc92835089a5ce4e1ac85aca4dddea758b5201b870e077cb5ac8e0553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "145081bf4bf85d25e14c330e68e03e19a02d9b97cf5e207b459ed7667577596d"
  end

  uses_from_macos "ruby"

  # patch to remove ask.rb file load, upstream pr ref, https://github.com/apicollective/apibuilder-cli/pull/89
  patch do
    url "https://github.com/apicollective/apibuilder-cli/commit/2f901ad345c8a5d3b7bf46934d97f9be2150eae7.patch?full_index=1"
    sha256 "d57b7684247224c7d9e43b4b009da92c7a9c9ff9938e2376af544662c5dfd6c4"
  end

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"config").write <<~EOS
      [default]
      token = abcd1234
    EOS

    assert_match "Profile default:",
                 shell_output("#{bin}/read-config --path config")
    assert_match "Could not find apibuilder configuration directory",
                 shell_output("#{bin}/apibuilder", 1)
  end
end
