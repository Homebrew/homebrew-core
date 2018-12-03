class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://github.com/django/django"
  url "https://github.com/django/django/archive/2.1.4.tar.gz"
  sha256 "b311afddad2e9c2fb85e6c299faf9627ad134309082a4590659f7e7f6aa0277d"
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
