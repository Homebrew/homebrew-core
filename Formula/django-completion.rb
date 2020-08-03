class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://github.com/django/django"
  url "https://github.com/django/django/archive/3.0.9.tar.gz"
  sha256 "cd68f50cb94724623c6dd9e4e60eadbd06f8dc7b6257e4a5c48980a385c3e095"
  license "BSD-3-Clause"
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
