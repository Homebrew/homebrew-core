class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.62.tgz"
  sha256 "d6961f75fd5cd329c70ad5581aa148bb36364367eeae40c82a499bdcae38647f"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "60adc1c535afa83c9a9b6140f70314166fb94d393f5a933888672d8c50b34deb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c78495efcec217c11bf5780a765b5871294883e82447087bf3fc53451e1fb84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c78495efcec217c11bf5780a765b5871294883e82447087bf3fc53451e1fb84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c78495efcec217c11bf5780a765b5871294883e82447087bf3fc53451e1fb84"
    sha256 cellar: :any_skip_relocation, sonoma:         "824d2b7a07241392f336672c7d3f514b4345ac1a78189fd422372ec611e4c691"
    sha256 cellar: :any_skip_relocation, ventura:        "824d2b7a07241392f336672c7d3f514b4345ac1a78189fd422372ec611e4c691"
    sha256 cellar: :any_skip_relocation, monterey:       "824d2b7a07241392f336672c7d3f514b4345ac1a78189fd422372ec611e4c691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51a9d36844726c3ffc2749818ffe30b8d9b45e5a4806e7b947b61d0d0270da96"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
