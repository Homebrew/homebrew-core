class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://github.com/django/django"
  url "https://github.com/django/django/archive/3.1.3.tar.gz"
  sha256 "ff91a38b1f59a07efa0185b2d2275734aae6bd3ff274f8b29b41160df84c6f50"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle :unneeded

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("source #{bash_completion}/django && complete -p django-admin.py")
  end
end
