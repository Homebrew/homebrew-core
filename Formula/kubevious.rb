require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.50.tgz"
  sha256 "dda2cbcd4e6339991f28f536ceed3c5f8384ca6a9e0a29769c20e55431896499"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a17db756cc5c55a870f6143c4617a544e3e8276f3e50db70e7cce366df8d6a01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5db6a683a2fe55f71a6f48dbc94f3ff8667d2280a728008d2dca2a7ceb2cecbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de58c673cb7bd03736c9f60fe9e1a76778be42297d82b9e9a3036f165ac04fd3"
    sha256 cellar: :any_skip_relocation, ventura:        "d765070d17b492f9fa9e04f4483c73cbc899a6324cfb00c4ef61fc4cef8130eb"
    sha256 cellar: :any_skip_relocation, monterey:       "66df5fbcc3cf6459a516a9787fa3b6b5229954012e39e8273622b911f61b699f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8435eead37ce14aae35b9be60b57e8f159d83879a9818ba0e6f0b568ec8a9aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfd36b225729d0034aa7008b7a36b9d6f0edaf9c47501fa4daa9261d2e097314"
  end

  # upstream issue to track node@18 support
  # https://github.com/kubevious/cli/issues/8
  depends_on "node@14"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"kubevious").write_env_script libexec/"bin/kubevious", PATH: "#{Formula["node@14"].opt_bin}:$PATH"
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/kubevious --version")

    (testpath/"deployment.yml").write <<~EOF
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx
      spec:
        selector:
          matchLabels:
            app: nginx
        replicas: 1
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.14.2
              ports:
              - containerPort: 80
    EOF

    assert_match "Lint Succeeded",
      shell_output("#{bin}/kubevious lint #{testpath}/deployment.yml")

    (testpath/"bad-deployment.yml").write <<~EOF
      apiVersion: apps/v1
      kind: BadDeployment
      metadata:
        name: nginx
      spec:
        selector:
          matchLabels:
            app: nginx
        replicas: 1
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.14.2
              ports:
              - containerPort: 80
    EOF

    assert_match "Lint Failed",
      shell_output("#{bin}/kubevious lint #{testpath}/bad-deployment.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}/kubevious guard #{testpath}/deployment.yml")

    assert_match "Guard Failed",
      shell_output("#{bin}/kubevious guard #{testpath}/bad-deployment.yml", 100)

    (testpath/"service.yml").write <<~EOF
      apiVersion: v1
      kind: Service
      metadata:
        labels:
          app: nginx
        name: nginx
      spec:
        type: ClusterIP
        ports:
        - name: http
          port: 80
          targetPort: 8080
        selector:
          app: nginx
    EOF

    assert_match "Guard Failed",
      shell_output("#{bin}/kubevious guard #{testpath}/service.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}/kubevious guard #{testpath}/service.yml #{testpath}/deployment.yml")
  end
end
