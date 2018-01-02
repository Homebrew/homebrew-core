class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://github.com/django/django"
  url "https://github.com/django/django/archive/2.0.1.tar.gz"
  sha256 "95ae8c5ad0bd72bc914064adfad451519b204236498804115411faa5bec20758"
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
