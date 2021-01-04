class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://github.com/django/django"
  url "https://github.com/django/django/archive/3.1.5.tar.gz"
  sha256 "b481d9ffd70c51bd20039a3b5cd33ffe3ac188ba95d29b37e88e456472317eaf"
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
