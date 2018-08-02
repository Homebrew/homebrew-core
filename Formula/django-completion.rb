class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://github.com/django/django"
  url "https://github.com/django/django/archive/2.1.tar.gz"
  sha256 "9e1750ba6caa78d982d283e2bc2a153892a1e288f0c1eb36ab95c4061eb7cbe5"
  head "https://github.com/django/django.git"

  bottle :unneeded

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("source #{bash_completion}/django && complete -p django-admin.py")
  end
end
