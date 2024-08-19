class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://www.djangoproject.com/"
  url "https://github.com/django/django/archive/refs/tags/5.1.tar.gz"
  sha256 "64509508cfcd461af9da5b139df8839a1ce8fa0c86683678bfc5ab01a392efa8"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bda63fe62812fbfd24b3de6712e558520bee9dd76bccd12a5cd70982d8cea3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bda63fe62812fbfd24b3de6712e558520bee9dd76bccd12a5cd70982d8cea3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bda63fe62812fbfd24b3de6712e558520bee9dd76bccd12a5cd70982d8cea3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bda63fe62812fbfd24b3de6712e558520bee9dd76bccd12a5cd70982d8cea3c"
    sha256 cellar: :any_skip_relocation, ventura:        "3bda63fe62812fbfd24b3de6712e558520bee9dd76bccd12a5cd70982d8cea3c"
    sha256 cellar: :any_skip_relocation, monterey:       "3bda63fe62812fbfd24b3de6712e558520bee9dd76bccd12a5cd70982d8cea3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11c4c45ddfee77abd3709f1f55bed0729169024f1c6ee81c87c048a6dc5ddb54"
  end

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}/django && complete -p django-admin'")
  end
end
