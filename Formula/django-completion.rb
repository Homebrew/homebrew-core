class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://github.com/django/django"
  url "https://github.com/django/django/archive/3.1.4.tar.gz"
  sha256 "393f64a8d7f9843323aa99684e908f9a1d1f2f685601a53a4aef6f00ff69f855"
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
