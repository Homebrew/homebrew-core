class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://www.djangoproject.com/"
  url "https://github.com/django/django/archive/4.2.4.tar.gz"
  sha256 "9679e61c2909d885771780155b2dfccb4134fbdb35f8dcdad281faf932c65612"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d91db70d0cb4e6f10054f3ee5d686241776d880e73eef2e4b669c89735927b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d91db70d0cb4e6f10054f3ee5d686241776d880e73eef2e4b669c89735927b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d91db70d0cb4e6f10054f3ee5d686241776d880e73eef2e4b669c89735927b7"
    sha256 cellar: :any_skip_relocation, ventura:        "1d91db70d0cb4e6f10054f3ee5d686241776d880e73eef2e4b669c89735927b7"
    sha256 cellar: :any_skip_relocation, monterey:       "1d91db70d0cb4e6f10054f3ee5d686241776d880e73eef2e4b669c89735927b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d91db70d0cb4e6f10054f3ee5d686241776d880e73eef2e4b669c89735927b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cb5630970238a6e665b498bc7e5daa3d6e0b6e9d756ede9ca9676fde0c40c4c"
  end

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}/django && complete -p django-admin'")
  end
end
