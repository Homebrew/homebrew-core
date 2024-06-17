class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://www.djangoproject.com/"
  url "https://github.com/django/django/archive/refs/tags/5.0.6.tar.gz"
  sha256 "0b077369e0130047c6782d029829e9250122744153cdb9566b1b0c0bddd42f87"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8cbe342c3a2eaf46622610335ed7a0b4326f40d67adde30f4d12c4d7b201c7cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ecd87d077b6fa69fdc23800fbf32f01417c7f6829c138c7129b5e0c2661d9a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fefc9261e2ec430ceaadd466e65f67871af6bd3aa4111d9d6b3c3c522d6b1aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "a76f34cdd857e9de32ebd2b08ea22b78052f7b684e857bf836284519ababf522"
    sha256 cellar: :any_skip_relocation, ventura:        "375a273ded1e46c9a7384072adec85bb65d04f07c06c7990224b1e04b6abe93c"
    sha256 cellar: :any_skip_relocation, monterey:       "525b6c697cfddc11f493cac544dd7dbda806475eaf2aff03f15e88ab0883f107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "525b6c697cfddc11f493cac544dd7dbda806475eaf2aff03f15e88ab0883f107"
  end

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}/django && complete -p django-admin'")
  end
end
