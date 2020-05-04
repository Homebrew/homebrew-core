class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://github.com/django/django"
  url "https://github.com/django/django/archive/3.0.6.tar.gz"
  sha256 "245cd69945784901d3b76cae8f577826c1f6df44e52f1bd8f10d3a8c49285f81"
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
